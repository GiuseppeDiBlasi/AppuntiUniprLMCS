
int G_VAL = 50;

int result(int x, int y){
  return x + y;
}

void swap(int& x, int& y){
  int temp = x;

  x = y;
  y = temp;

}

int main(){
  int x = 0;

  int y = 3;

  int z = result(x, y);

  swap(z, y);


  int arr[] = {10, 50, 30, -2, G_VAL};
  const int DIM = 5;

  for(int i = 0; i < DIM; ++i){
      ++arr[i];
  }

  return 0;

}
