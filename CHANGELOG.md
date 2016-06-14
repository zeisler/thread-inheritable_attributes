## v1.1.0.beta1 - 2016-06-14

### Fix
Add request_store gem as an optional dependency for when working within the context of a multi-threaded web server.
Addresses the use of `Thread.current` and replaces it with `RequestStore` when the gem can be required.

> if you use Thread.current, and you use [a multi-threaded web server] ..., watch out! Values can stick around longer than you'd expect, and this can cause bugs."

> -- <cite>[request_store docs](https://github.com/steveklabnik/request_store#the-problem)</cite>

## v1.0.0 - 2016-05-25

No changes from v0.2.0, but it is being promoted to production ready.
It's been used on multiple production environments for 3 months without issues.

## v0.2.0 - 2016-03-14

### Fix
- Addressing issue of args not being passed to thread block when creating a Thread and passing args to the initializer.

## Initial Release v0.1.0
