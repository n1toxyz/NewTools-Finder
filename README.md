# NewTools-Finder
New implementation of the Pharo Finder in Spec2

## To load 

```
Metacello new
 	 baseline: 'NewToolsFinder';
 	 repository: 'github://n1toxyz/NewTools-Finder:main/src';
 	 load.
```

## TODO

 The tool is already usable, but does not implement all kinds of searches of the old Finder tool yet.

- [ ] Implement missing searches as subclasses of StFinderSearch, e.g. `StFinderExampleSearch`
- [ ] Implement tests!!! Right now there are none...
- [ ] Improve GUI. Ideas welcome!
  - provide more information about the search environment (how many packages are selected, etc), e.g. by adding an StatusBar
  - explore ways to display results in a better way
- [ ] Check baseline for missing dependencies
