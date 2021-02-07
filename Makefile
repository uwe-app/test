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

tutorials: integration-test-tutorial

test: clean tutorials

.PHONY: clean test tutorials
