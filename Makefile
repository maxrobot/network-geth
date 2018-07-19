SHELL=/bin/bash

clean:
	@rm -rf ./account1/geth*
	@rm -rf ./account2/geth*

boot:
	@bootnode -nodekey boot.key -verbosity 9 -addr :30310

