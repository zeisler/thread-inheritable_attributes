## v1.1.0.beta1 - 2016-06-14

### Fix
Addresses the use of `Thread.current` and the potential issues when used in the context of multi-threaded web server and replaces it with `RequestStore` when the gem can be loaded.

[request_store](https://github.com/steveklabnik/request_store) is an optional dependency for when working within the context of a multi-threaded web server. 
In that context Threads can be reused for different request causing state from a previous request to stick around to the next request. 
Unless your are manually reinitializing or clearing the state in your own Rack Middleware (at the start of a request) it is recommended that you also include the request_store gem.


> if you use Thread.current, and you use [a multi-threaded web server] ..., watch out! Values can stick around longer than you'd expect, and this can cause bugs."

> -- <cite>[request_store docs](https://github.com/steveklabnik/request_store#the-problem)</cite>

## v1.0.0 - 2016-05-25

No changes from v0.2.0, but it is being promoted to production ready.
It's been used on multiple production environments for 3 months without issues.

## v0.2.0 - 2016-03-14

### Fix
- Addressing issue of args not being passed to thread block when creating a Thread and passing args to the initializer.

## Initial Release v0.1.0
