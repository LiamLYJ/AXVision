#ifndef CONFIG_HPP
#define CONFIG_HPP

#include "CommonInclude.hpp" 

namespace common 
{

class Config
{
public:
    ~Config();  // close the file when deconstructing 
    
    // set a new config file 
    static void setParameterFile( const std::string& filename ); 
    
    // access the parameter values
    template< typename T >
    static T get( const std::string& key )
    {
        return T( Config::config_->file_[key] );
    }
private:
    static std::shared_ptr<Config> config_; 
    cv::FileStorage file_;
    
    Config () {} // private constructor makes a singleton

    DISALLOW_COPY_AND_ASSIGN(Config);
};
} // namespace common

#endif // CONFIG_H
