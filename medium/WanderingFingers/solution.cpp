// Credit goes to lordtnt! Catch him on -> https://www.reddit.com/user/lordtnt

#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <algorithm>

class FLDict {
    public:
        bool load(const std::string&);
        std::vector<std::string> matchWords(const std::string, size_t);
    private:
        std::vector<std::string>& group(const std::string&);
        static size_t lcss(const std::string&, const std::string&);
    private:
        std::vector<std::string> data[26][26];
};

int main() {
    FLDict dict;
    if (!dict.load("enable1.txt")) { std::cerr << "No dict!\n"; return 1; }

    std::string input[] = {"qwertyuytresdftyuioknn", "gijakjthoijerjidsdfnokg"};
    for (auto& s : input) {
        for (auto& w : dict.matchWords(s, 5))
            std::cout << w << " ";
        std::cout << "\n\n";
    }
}


bool FLDict::load(const std::string& fname) {
    std::ifstream fin(fname);
    if (!fin) return false;
    std::string w;
    while (fin >> w) group(w).push_back(w);
    return true;
}

std::vector<std::string> FLDict::matchWords(const std::string s, size_t minLen) {
    std::vector<std::string> words;
    for (auto& w : group(s))
        if (w.size() >= minLen && lcss(w, s) == w.size())
            words.push_back(w);
    return words;
}

std::vector<std::string>& FLDict::group(const std::string& s) {
    return data[s.front()-'a'][s.back()-'a'];
}

size_t FLDict::lcss(const std::string& w, const std::string& s) {
    std::vector<std::vector<int>> p(w.size()+1, std::vector<int>(s.size()+1));
    for (size_t i = 1; i <= w.size(); ++i)
        for (size_t j = 1; j <= s.size(); ++j)
            p[i][j] = w[i-1] == s[j-1] ?
                std::max(p[i-1][j-1], p[i-1][j]) + 1 :
                std::max(p[i-1][j], p[i][j-1]);
    return p[w.size()][s.size()];
}
