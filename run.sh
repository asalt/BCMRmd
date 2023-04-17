
# Set default values
input_file="${1:-./BCMRmd/index.Rmd}"
parent_dir_name="$(basename "$(pwd)")"
output_file="${parent_dir_name}_BCMRmd.html"
output_file_with_path="${2:-../${output_file}}" # relative to BCMRmd/Index
params="${3:-list(param1 = 'default_value1', param2 = 'default_value2')}"

#Rscript -e "rmarkdown::render(input = '$(abspath $(1))', output_file = '$(abspath $(2))', params = $(3))"                                                                
Rscript -e "rmarkdown::render(input = '$input_file', output_file = '$output_file_with_path')" 
