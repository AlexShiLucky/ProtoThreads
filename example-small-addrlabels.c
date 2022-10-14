#include <stdio.h>

#define LC_CONCAT2(s1, s2) s1##s2
#define LC_CONCAT(s1, s2) LC_CONCAT2(s1, s2)
#define LC_LINE_LABEL LC_CONCAT(LC_LABEL, __LINE__)

typedef void * lc_t;

struct pt {
  lc_t lc;
};

static int protothread1_flag, protothread2_flag;

static int
protothread1(struct pt *pt)
{
    {                                           \
        char PT_YIELD_FLAG = 1;                 \
        do {                                    \
            if((pt)->lc != ((void *)0)) {       \
                goto *(pt)->lc;                 \
            }                                   \
        } while(0);

        while(1) {
            do {                                                                \
                do { LC_LINE_LABEL: ((pt)->lc) = &&LC_LINE_LABEL; } while(0);   \
                if(!(protothread2_flag != 0)) { return 0; }                     \
            } while(0);
            
            printf("Protothread 1 running\n");

            protothread2_flag = 0;
            protothread1_flag = 1;
        }

        ; PT_YIELD_FLAG = 0;        \
        (pt)->lc = ((void *)0);     \
        return 3;                   \
    };
}

static int
protothread2(struct pt *pt)
{
    {                                           \
        char PT_YIELD_FLAG = 1;                 \
        do {                                    \
            if((pt)->lc != ((void *)0)) {       \
                goto *(pt)->lc;                 \
            }                                   \
        } while(0);

        while(1) {
            protothread2_flag = 1;

            do {                                                                \
                do { LC_LINE_LABEL: ((pt)->lc) = &&LC_LINE_LABEL; } while(0);   \
                if(!(protothread1_flag != 0)) { return 0; }                     \
            } while(0);    

            printf("Protothread 2 running\n");

            protothread1_flag = 0;
        }

        ; PT_YIELD_FLAG = 0;      \
        (pt)->lc = ((void *)0);   \
        return 3;                 \
    };
}

static struct pt pt1, pt2;
int
main(void)
{
    (&pt1)->lc = ((void *)0);
    (&pt2)->lc = ((void *)0);

    while(1) {
        protothread1(&pt1);
        protothread2(&pt2);
    }
}
