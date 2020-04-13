install:
	zef install .

force-install:
	zef install --force-install .

test:
	prove -j 2 -e 'raku -Ilib' t/
