#include <stdio.h>
#include <sys/time.h>
#include <time.h>
#include <stdlib.h>

#define N 32  //这里定义了矩阵的阶级，这里用一个32x32的方形矩阵做例子

void calculate_object(const double x[][N],
    const double y[][N],
    const double z[][N],
    const double v[][N],
    const double a[][N],
    const double *interval) {
  for (int i=0; i!=N; ++i) {
    for (int j=0; j!=N; ++j) {
      double v_delt = a[i][j] * (*interval);
      double v_new = v[i][j] + v_delt;
      double s_new = v[i][j] * (*interval) +
        a[i][j] * (*interval) * (*interval) / 2.0;
    }
  }
}

int main(void) {
  struct timeval start, end;
  double elapsed_time;

  double *h_x, *h_y, *h_z, *h_v, *h_a;
  double *dev_x, *dev_y, *dev_z, *dev_v, *dev_a;
  double *h_interval;
  double *dev_interval;


  h_x = (double *)malloc(sizeof(double) * N * N);
  h_y = (double *)malloc(sizeof(double) * N * N);
  h_z = (double *)malloc(sizeof(double) * N * N);
  h_v = (double *)malloc(sizeof(double) * N * N);
  h_a = (double *)malloc(sizeof(double) * N * N);

  h_interval = (double*)malloc(sizeof(double));


  for (int i = 0; i < N * N; i++) {
    h_x[i] = 2 * i + 1.0;
    h_y[i] = -1 * i + 5.0;
    h_z[i] = -1 * i + 3.0;
    h_v[i] = -1 * i + 4.0;
    h_a[i] = -1 * i + 8.0;
  }
  *h_interval = 3.0;
  calculate_object((double (*)[N])h_x, (double (*)[N])h_y, (double (*)[N])h_z,
      (double (*)[N])h_v, (double (*)[N])h_z, h_interval);
}
