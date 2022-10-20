#include <stdio.h>
#include <setjmp.h>

typedef struct lc {
  jmp_buf env;
  int isset;
} lc_t;

struct pt {
  lc_t lc;
};

static int protothread1_flag, protothread2_flag;

static int
protothread1(struct pt *pt)
{
    {                                       \
        char PT_YIELD_FLAG = 1;             \
        do {                                \
            if(((pt)->lc).isset) {          \
                longjmp(((pt)->lc).env, 0); \
            }
        } while(0);

        while(1) {
            do {                                \
                do {                            \
                    ((pt)->lc).isset = 1;       \
                    setjmp(((pt)->lc).env);     \
                } while(0);                     \
                if(!(protothread2_flag != 0)) { \
                    return 0;                   \
                }                               \
            } while(0);

            printf("Protothread 1 running\n");

            protothread2_flag = 0;
            protothread1_flag = 1;
        }

        PT_YIELD_FLAG = 0;          \
        do {                        \
            ((pt)->lc).isset = 0;   \
        } while (0);                \
        return 3;                   \
    };
}

static int
protothread2(struct pt *pt)
{
    {                                       \
        char PT_YIELD_FLAG = 1;             \
        do {                                \
            if(((pt)->lc).isset) {          \
                longjmp(((pt)->lc).env, 0); \
            }                               \
        } while(0);

        while(1) {
            protothread2_flag = 1;

            do {                                \
                do {                            \
                    ((pt)->lc).isset = 1;       \
                    setjmp (((pt)->lc).env);    \
                } while(0);                     \
                if(!(protothread1_flag != 0)) { \
                    return 0;                   \
                }                               \
            } while(0);

            printf("Protothread 2 running\n");

            protothread1_flag = 0;
        }

        PT_YIELD_FLAG = 0;          \
        do {                        \
            ((pt)->lc).isset = 0;   \
        } while (0);                \
        return 3;                   \
    };
}

static struct pt pt1, pt2;
int
main(void)
{
    do { ((&pt1)->lc).isset = 0; } while (0);
    do { ((&pt2)->lc).isset = 0; } while (0);

    while(1) {
        protothread1(&pt1);
        protothread2(&pt2);
    }
}
