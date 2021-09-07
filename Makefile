# © Mikhail Gozhev <m@gozhev.ru> / Autumn 2021 / Moscow, Russia

TARGETS := \
	uenvmod \
	davunpack \

CCXXFLAGS := \
	-Werror \
	-Wall \
	-Wpedantic \

CXXFLAGS := $(CCXXFLAGS) \
	-std=gnu++17 \

CFLAGS := $(CCXXFLAGS) \
	-std=gnu99 \

CC := gcc
CXX := g++

DEST_PREFIX :=
BUILD_PREFIX := build/bb/

.PRECIOUS: $(DEST_PREFIX)
.PRECIOUS: $(BUILD_PREFIX)

TARGETS := $(addprefix $(DEST_PREFIX),$(TARGETS))

.PHONY: all
all: $(TARGETS)

.SUFFIXES:

.PRECIOUS: $(BUILD_PREFIX)%.cc.o
$(DEST_PREFIX)% : $(BUILD_PREFIX)%.cc.o | $(DEST_PREFIX)
	$(CXX) -o $@ $(LDFLAGS) $^

.PRECIOUS: $(BUILD_PREFIX)%.c.o
$(DEST_PREFIX)% : $(BUILD_PREFIX)%.c.o | $(DEST_PREFIX)
	$(CC) -o $@ $(LDFLAGS) $^

$(BUILD_PREFIX)%.cc.o : %.cc | $(BUILD_PREFIX)
	$(CXX) -o $@ -c $(CXXFLAGS) $^

$(BUILD_PREFIX)%.c.o : %.c | $(BUILD_PREFIX)
	$(CC) -o $@ -c $(CFLAGS) $^

%/:
	mkdir -p $@

CLEAN += $(call rm_files,$(wildcard \
	$(patsubst $(DEST_PREFIX)%,$(BUILD_PREFIX)%*.o,$(TARGETS))))
DISTCLEAN += $(call rm_files,$(TARGETS))
DISTCLEAN += $(call rm_dirs,$(DEST_PREFIX))

ifneq ($(BUILD_PREFIX),$(DEST_PREFIX))
CLEAN += $(call rm_dirs,$(BUILD_PREFIX))
endif

.PHONY: clean
clean:
	$(CLEAN)

.PHONY: distclean
distclean: clean
	$(DISTCLEAN)

rm_files = $(if $(wildcard $(1)),-rm -f $(1)$(NL),)
rm_dirs = $(call rm_dirs1,$(filter-out ./ ../,$(call rsort,$(1))))
rm_dirs1 = $(if $(wildcard $(1)),-rmdir -p $(1)$(NL),)
rsort = $(shell sed 's/ /\n/g' <<< '$(1)' | sort -r)

define NL


endef
