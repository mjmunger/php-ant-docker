This is the docker file for php-ant images.

It requires the following sources be available in the docker directory:

php 7.1.9
libsodium-1.0.12

Currently, this builds and compiles php with the correct flags to over come limitations in the default debian packages (namely: readline is broken and does not work properly). 

It uses libsodium-1.0.12 and the PECL libsodium 1.0.6 package to remain compatible with the proper namespacing. (This will likely change wehn PHP 7.2 comes out, which adds libsodium by default and changes the namespace to the global name space).