#include "cmake_config.h"
#include <boost/program_options.hpp>
#include <fingerprint_db.hh>
#include <iostream>
#include <string>
#include <vector>

using std::vector;

namespace po = boost::program_options;
namespace si = sound_index;

void query(std::string &dbname, std::string &queryFile, float criteria) {
    std::vector<std::string> res;
    si::fingerprint_db db;
    db.open(dbname);
    db.query_scan(queryFile, res, criteria);
    db.close();

    for (size_t i = 0; i < res.size(); ++i) {
        std::cout << res[i] << std::endl;
    }

}

template <typename T>
std::string to_string_with_precision(const T a_value, const int n = 6)
{
    std::ostringstream out;
    out.precision(n);
    out << std::fixed << a_value;
    return out.str();
}

void init(int argc, char *argv[]) {

    std::vector<std::string> dbname;
    std::string queryFile;
    std::string processedQueryFile;
    float criteria;
    
    po::options_description generic("Program options");
    generic.add_options()
        ("help,h", "Print help message and return, everything else is ignored")
        ("version,v", "Print version and return. Everything else is ignored");

    po::positional_options_description positional;
        positional.add("dbname", -1);

    double maxCriteria = si::fingerprint_db::macro_sz*sizeof(uint32_t)*8;
    double defaultCriteria = 0.35*maxCriteria;
    std::string criteriaHint = std::string("Criteria for hit; between 0 and ") +
                                to_string_with_precision(maxCriteria,1) +
                                std::string(". Default ") +
                                to_string_with_precision(defaultCriteria,1) +
                                std::string(". This is the max distance allowed for something to be called a hit");
    po::options_description hidden("Settings");
    hidden.add_options()
	("query,q", po::value<std::string>(), "Audio query file")
            ("criteria,c", po::value<float>(), criteriaHint.c_str())
	("dbname,d", po::value<std::vector<std::string>>(), "Database names")
	("processed-query,p", po::value<std::string>(), "Preprocessed query file");

    po::options_description all("Allowed options");
    all.add(generic).add(hidden);

    po::options_description visible("Program options");
    visible.add(generic);

    po::variables_map vm;
    po::store(po::command_line_parser(argc, argv).options(all).positional(positional).run(), vm);

    if (vm.count("help")) {
        std::cout << "Usage: ismir_query SETTINGS" << std::endl << std::endl;
        std::cout << generic << std::endl;

        std::cout << hidden << std::endl;

        exit(0);
    }

    if (vm.count("version")) {
        std::cout << "ismir_query xcorrsound version " << XCORRSOUND_VERSION << std::endl;
        return;
    }

    bool queryExists = false;

    if (vm.count("query")) {
        queryFile = vm["query"].as<std::string>();
        queryExists = true;
    } else {
        std::cout << "A query file must be provided" << std::endl;
        exit(1);
    }

    if (vm.count("processed-query")) {
        processedQueryFile = vm["processed-query"].as<std::string>();
    } else {
        queryExists = true;
    }

      if (vm.count("criteria")) {
            criteria = vm["criteria"].as<float>();
        } else {
            criteria = defaultCriteria;
        }

    if (vm.count("dbname")) {
        dbname = vm["dbname"].as<std::vector<std::string>>();
    } else {
        std::cout << "dbname must be provided" << std::endl;
        exit(1);
    }

    for (size_t i = 0; i < dbname.size(); ++i) {
        std::string current_dbname(dbname[i]);

        query(current_dbname, queryFile, criteria);
    }

}

int main(int argc, char *argv[]) {
    init(argc, argv);
    return 0;
}
