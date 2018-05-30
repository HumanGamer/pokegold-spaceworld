MD5 := md5sum -c

.PHONY: all compare clean mostlyclean text

.SUFFIXES:
.SUFFIXES: .asm .o .gb .png
.SECONDEXPANSION:
.PRECIOUS: %.1bpp %.2bpp %.pic

ROMS := pokegold-spaceworld.gb
BASEROM := baserom.gb
OBJS := home.o main.o audio.o sram.o wram.o hram.o shim.o

# Link objects together to build a rom.
all: $(ROMS) compare

tools:
	$(MAKE) -C tools/

define DEP
$1: $2 $$(shell tools/scan_includes $2)
	rgbasm -E -o $$@ $$<
endef

ifeq (,$(filter clean tools,$(MAKECMDGOALS)))
$(info $(shell $(MAKE) -C tools))

$(foreach obj, $(OBJS), $(eval $(call DEP,$(obj),$(obj:.o=.asm))))

endif

shim.asm: tools/make_shim.py shim.sym
	python tools/make_shim.py -w -- $(filter-out $<, $^) > $@

$(ROMS): $(OBJS)
	rgblink -d -n $(ROMS:.gb=.sym) -m $(ROMS:.gb=.map) -O $(BASEROM) -o $@ $^
	rgbfix -f lh -k 01 -l 0x33 -m 0x03 -p 0 -r 3 -t "POKEMON2GOLD" $@

compare: $(ROMS)
	@$(MD5) roms.md5

# Remove files generated by the build process.
clean:
	rm -rf $(ROMS) $(OBJS) $(ROMS:.gb=.sym) build/* shim.asm
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' -o -iname '*.pic' -o -iname '*.pcm' \) -exec rm {} +

# Remove files except for graphics.
mostlyclean:
	rm -rf $(ROMS) $(OBJS) $(ROMS:.gb=.sym) build/* shim.asm
	find . \( -iname '*.pcm' \) -exec rm {} +

gfx/sgb/sgb_border_alt.2bpp: tools/gfx += --trim-whitespace
gfx/sgb/sgb_border.2bpp: tools/gfx += --trim-whitespace
gfx/title/title.2bpp: tools/gfx += --trim-whitespace
gfx/trainer_card/leaders.2bpp: tools/gfx += --trim-whitespace
gfx/minigames/slots.2bpp: tools/gfx += --trim-whitespace
gfx/minigames/poker.2bpp: tools/gfx += --trim-whitespace
gfx/intro/purin_pikachu.2bpp: tools/gfx += --trim-whitespace

%.2bpp: %.png
	rgbgfx -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -o $@ $@)

%.1bpp: %.png
	rgbgfx -d1 -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -d1 -o $@ $@)

%.tilemap: %.png
	rgbgfx -t $@ $<

%.pic:  %.2bpp
	tools/pkmncompress $< $@
