BIN_UWE := uwe
TARGET := target

clean:
	@rm -rf $(TARGET)
	@mkdir $(TARGET)

integration-test-tutorial:
	@(cd target && uwe new integration-test-tutorial)
	@(cd target/integration-test-tutorial \
		&& uwe build \
		&& yarn add cypress --dev \
		&& uwe task init-test \
		&& uwe test)

esbuild-hook-tutorial:
	@(cd target && uwe new esbuild-hook-tutorial)
	@(cd target/esbuild-hook-tutorial \
		&& cp -f ../../fixtures/esbuild-hook-tutorial/package.json . \
		&& yarn add esbuild --dev \
		&& cp -f ../../fixtures/esbuild-hook-tutorial/site.toml . \
		&& cp -f ../../fixtures/esbuild-hook-tutorial/index.md ./site \
		&& mkdir -p site/src \
		&& cp -f ../../fixtures/esbuild-hook-tutorial/main.js ./site/src \
		&& uwe build --exec)

tutorials: integration-test-tutorial esbuild-hook-tutorial

test: clean tutorials

.PHONY: clean test tutorials
