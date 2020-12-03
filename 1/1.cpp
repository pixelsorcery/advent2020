#include <iostream>
#include <string>

using namespace std;

string input;

int main()
{
    int *nums = new int[100000];
    int lines = 0;
    while (getline(std::cin, input))
    {
        nums[lines] = atoi(input.c_str());
        lines++;
    }

    for (int i = 0; i < lines; i++)
    {
        for (int j = 0; j < lines; j++)
        {
            for (int k = 0; k < lines; k++)
            {
                if (nums[i] + nums[j] + nums[k] == 2020)
                {
                    cout << nums[i] * nums[j] * nums[k] << endl;
                    goto end;
                }
            }
        }
    }
end:
    delete[] nums;
    return 0;
}
