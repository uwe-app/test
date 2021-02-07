BIN_UWE := uwe
TARGET := target

clean:
	@rm -rf $(TARGET)
	@mkdir $(TARGET)

getting-started:
	@(cd $(TARGET) && uwe new basic-website)
	@(cd $(TARGET)/basic-website && uwe build)

using-javascript-transpiler:
	@(cd $(TARGET) && uwe new esbuild-hook)
	@(cd $(TARGET)/esbuild-hook \
		&& cp -f ../../fixtures/esbuild-hook/package.json . \
		&& yarn add esbuild --dev \
		&& cp -f ../../fixtures/esbuild-hook/site.toml . \
		&& cp -f ../../fixtures/esbuild-hook/index.md ./site \
		&& mkdir -p site/src \
		&& cp -f ../../fixtures/esbuild-hook/main.js ./site/src \
		&& uwe build --exec)

adding-integration-tests:
	@(cd $(TARGET) && uwe new test-project)
	@(cd $(TARGET)/test-project \
		&& uwe build \
		&& yarn add cypress --dev \
		&& uwe task init-test \
		&& uwe test)

tutorials: getting-started using-javascript-transpiler adding-integration-tests

test: clean tutorials

.PHONY: clean test tutorials
