.PHONY: start
start:
	@BASE_URL=https://lekkiphaseoneshortlets.com elm-land server

local:
	@BASE_URL=http://localhost:80 elm-land server
