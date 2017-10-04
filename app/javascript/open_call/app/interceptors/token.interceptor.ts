import { Injectable } from '@angular/core';
import { HttpEvent, HttpInterceptor, HttpHandler, HttpRequest } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { Meta } from '@angular/platform-browser';

@Injectable()
export class TokenInterceptor implements HttpInterceptor {
  constructor(private meta:Meta) {}

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    let tag = this.meta.getTag('name="csrf-token"')
    const changedReq = req.clone({
      setHeaders: { 'X-CSRF-TOKEN': tag.content }
    });
    return next.handle(changedReq);
  }
}
