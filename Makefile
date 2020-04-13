RAKU = raku -Ilib --stagestats

install:
	zef install .

force-install:
	zef install --force-install .

.t-temps/%.t: t/%.t
	mkdir -p .t-temps
	prove -j 4 -e '$(RAKU)' $< | tee $@

test:
	prove -j 4 -e '$(RAKU)' t/

examples:
	for i in examples/*; do $(RAKU) $$i; done

.PHONY: install examples test force-install
