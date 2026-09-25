clean:
	rm -rf $(BUILD)

stpclean:
	rm -f $(CURDIR)/.build
	rm -f $(CURDIR)/.configure
	rm -f $(CURDIR)/.prepare

distclean:
	rm -rf $(CURDIR)/.source

