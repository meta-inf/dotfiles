#include <iostream>
#include <vector>
#include <string>
#include <cmath>
using namespace std;

int main() {
	string cur;
	double sum = 0, sumsq = 0;
	int n = 0;
	while (getline(cin, cur)) {
		double cv = stof(cur);
		sum += cv;
		sumsq += cv * cv;
		n += 1;
	}
	double mean = sum / n,
		   sdd  = sqrt((sumsq - n * mean * mean) / (n)), // - 1),
		   ciw  = sdd / sqrt(float(n)-1);
	cout << mean << ' ' << sdd << ' ' << ciw << ' ' << n << endl;
	return 0;
}
