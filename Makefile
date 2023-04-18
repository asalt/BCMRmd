# notes
# =: assignment
# wildcard 
# ( patsubst find_pat  replace_pat input_list )
# Directories
#SRC_DIR := BCMRmd
SRC_DIR := BCMRmd
TEST_DIR := test
PARENT_DIR := $(notdir $(realpath ".."))


# exclude files for two reasons
# a) the file is not ready for testing
# b) we define the rule for that file separately
EXCLUDE_FILES := $(SRC_DIR)/MASIC.Rmd $(SRC_DIR)/PSMs.Rmd $(SRC_DIR)/index.Rmd $(SRC_DIR)/E2G.Rmd $(SRC_DIR)/PCA.Rmd $(SRC_DIR)/tackle.Rmd $(SRC_DIR)/E2G.Rmd

RMD_FILES := $(wildcard $(SRC_DIR)/*.Rmd)
RMD_FILES := $(filter-out $(EXCLUDE_FILES), $(RMD_FILES))

HTML_FILES := $(patsubst $(SRC_DIR)/%.Rmd, $(TEST_DIR)/%.html, $(RMD_FILES))
# HTML_FILES := $(filter-out $(TEST_DIR)/PCA.html, $(HTML_FILES))
# HTML_FILES := $(patsubst $(SRC_DIR)/%.Rmd, $(TEST_DIR)/%.html, $(filter-out $(EXCLUDE_FILES), $(RMD_FILES)))

PCA_OUTPUTS := $(foreach c, T F, $(foreach s, T F, $(TEST_DIR)/PCA_center_$(c)_scale_$(s).html))
CLUSTER_OUTPUTS := $(foreach m, kmeans pam , $(TEST_DIR)/cluster_method_$(m).html)


REPORT_OUT := "$(PARENT_DIR)_BCMRmd.html"

define render_rmd
	Rscript -e "rmarkdown::render(input = '$(abspath $(1))', output_file = '$(abspath $(2))', params = $(3))"
endef

.PHONY: all print_pca print_cluster clean report 

#all: $(CLUSTER_OUTPUTS) $(PCA_OUTPUTS)

cluster: $(CLUSTER_OUTPUTS)

pca: $(PCA_OUTPUTS)


#
#$(REPORT_OUT): $(REPORT_SRC) | $(TEST_DIR)
	#$(call render_rmd,$<,$@,"list(param1 = 'value1', param2 = 'value2')")
all := $(REPORT_OUT)
	$(call render_rmd,index.Rmd,$@)



print_pca:
	@echo "$(wildcard $(SRC_DIR)/[Pp][Cc][Aa].Rmd)"
	@echo "$(PCA_OUTPUTS)"

print_cluster:
	@echo "$(CLUSTER_OUTPUTS)"


#$(TEST_DIR)/PCA_center_%_scale_%.html: $(SRC_DIR)/PCA.Rmd | $(TEST_DIR)
# $(TEST_DIR)/PCA_center_%_scale_%.html: $(wildcard $(SRC_DIR)/[Pp][Cc][Aa].Rmd) | $(TEST_DIR)
# 	$(call render_rmd,$<,$@,"list(center = $(word 2,$(subst _, ,$(basename $@))), scale = $(word 4,$(subst _, ,$(basename $@))))")

# $(TEST_DIR)/PCA_center_%_scale_%.html: $(wildcard $(SRC_DIR)/[Pp][Cc][Aa].Rmd) | $(TEST_DIR)
# 	$(call render_rmd,$<,$@,"list(center = $(word 2,$(subst _, ,$(basename $@))), scale = $(word 4,$(subst _, ,$(basename $@))))")


#$(TEST_DIR)/PCA_center_%_scale_%.html: $(PCA_OUTPUTS)
#$(TEST_DIR)/PCA_center_%_scale_%.html: $(wildcard $(SRC_DIR)/PCA.Rmd) | $(TEST_DIR)
#	$(call render_rmd, $(SRC_DIR)/PCA.Rmd, $@, list(center=T, scale=T))

# $(TEST_DIR)/PCA_center_%_scale_%.html: $(SRC_DIR)/PCA.Rmd | $(PCA_OUTPUTS)
# 	@echo "Generating $@ from $<"
# 	touch $@

$(TEST_DIR)/PCA_center_T_scale_T.html: $(SRC_DIR)/PCA.Rmd
	$(call render_rmd, $(SRC_DIR)/PCA.Rmd, $@, list(center=T, scale=T))

$(TEST_DIR)/PCA_center_F_scale_T.html: $(SRC_DIR)/PCA.Rmd
	$(call render_rmd, $(SRC_DIR)/PCA.Rmd, $@, list(center=F, scale=T))

$(TEST_DIR)/PCA_center_T_scale_F.html: 
	$(call render_rmd, $(SRC_DIR)/PCA.Rmd, $@, list(center=T, scale=F))
	#$(call render_rmd, "$<", $@, 'list(center=T, scale=F)')

$(TEST_DIR)/PCA_center_F_scale_F.html: 
	$(call render_rmd, $(SRC_DIR)/PCA.Rmd, $@, list(center=F, scale=F))

$(TEST_DIR)/cluster_method_kmeans.html: $(SRC_DIR)/cluster.Rmd
	$(call render_rmd, $(SRC_DIR)/cluster.Rmd, $@, list(method=\"kmeans\"))

$(TEST_DIR)/cluster_method_pam.html: $(SRC_DIR)/cluster.Rmd
	$(call render_rmd, $(SRC_DIR)/cluster.Rmd, $@, list(method=\"pam\"))

$(TEST_DIR):
	mkdir -p $(TEST_DIR)

clean:
	rm -vf $(TEST_DIR)/*.html
