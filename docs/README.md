# Poblano Toolbox for MATLAB

## Documentation

To generate the documentation in HTML that will appear in the MATLAB
Dcoumentation, you can run the following MATALB command from within
this directory:

```
opts.stylesheet = 'mxdom2simplehtml_poblano.xsl'; D = dir('*_doc.m'); for i = 1:length(D), publish(D(i).name, opts); end
```

All of the HTML files will be placed in the ```html``` subdirectory.

The file ```html/helptoc.xml``` specifies the order of the
documentation as it will appear in the MATLAB Documentation.