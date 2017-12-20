max2markdown=libexec/max2markdown/bin/max2markdown
quasi=libexec/quasi/bin/quasi

default:
	echo "Usage: make all"

all: doc quasi test

doc:
	$(max2markdown) source/mt/*.mtxt > README.md

quasi: $(quasi)
	quasi -f . source/mt/*.mtxt
	chmod +x bin/ix2java.sh

test:
	mkdir -p _gen
	bin/ix2java.sh source/ix/ix.base/StringBuffer.ix > _gen/StringBuffer.java

$(quasi):
	make -C libexec/quasi

clean:
	rm -rf bin
	rm -rf _gen
	make -C libexec/quasi clean
