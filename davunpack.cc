// © Mikhail Gozhev <m@gozhev.ru> / Autumn 2021 / Moscow, Russia

#include <iostream>
#include <fstream>

int main(int argc, char** argv)
{
	constexpr static int buf_size = 4 * 1024;
	int pattern_shift = 0;
	uint8_t pattern[] = {
		0xBA, 0xCD, 0xBC, 0xFE, 0xD6, 0xCA, 0xDD, 0xD3,
		0xBA, 0xB9, 0xA3, 0xAB, 0xBF, 0xCB, 0xB5, 0xBE};
	int const pattern_size = static_cast<int>(::std::size(pattern));
	::std::ifstream fin_a {};
	::std::ifstream fin_b {};
	::std::ofstream fout {};
	uint8_t buf_a[buf_size] = {};
	//uint8_t buf_b[buf_size] = {};
	int count = 0;
	int count_total = 0;
	if (argc < 3) {
		::std::cout << "invalid arguments" << ::std::endl;
		return -1;
	}
	char* path_a = argv[1];
	//char* path_b = argv[2];
	char* path_out = argv[2];

	fin_a.open(path_a, ::std::ios::in | ::std::ios::binary);
	//fin_b.open(path_b, ::std::ios::in | ::std::ios::binary);
	fout.open(path_out, ::std::ios::out | ::std::ios::binary);

	int pattern_shift_trigger = 0;
	for (;;) {
		fin_a.read(reinterpret_cast<char*>(buf_a), buf_size);
		//fin_b.read(reinterpret_cast<char*>(buf_b), 1024);
		//count = ::std::min(fin_a.gcount(), fin_b.gcount());
		count = fin_a.gcount();
		for (int i = 0; i < count; ++i) {
			buf_a[i] ^= pattern[(pattern_shift + i) % pattern_size];
			if (++pattern_shift_trigger == pattern_size) {
				pattern_shift_trigger = 0;
				pattern_shift = (pattern_shift + 1) % pattern_size;
			}
		}
		fout.write(reinterpret_cast<char*>(buf_a), count);
		count_total += count;
		if (!fin_a) {
			break;
		}
	}
	fin_a.close();
	fout.close();
	::std::cout << "total: " << count_total << ::std::endl;
	return 0;
}
