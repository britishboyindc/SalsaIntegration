public virtual class Web_Callouts_bfc {

//Generic Class to handle all HTTP callouts...

protected virtual HttpRequest createRequest(String Method, String path) {
    HttpRequest req = new HttpRequest();
    req.setTimeout(90000);
    req.setEndpoint(path);
    req.setMethod(method == null ? 'GET' : method);
    return req;
 }
 
 protected virtual HttpResponse execute(HttpRequest req) {
    return new http().send(req);
}

protected virtual String getResponseBody(HttpResponse r, HttpRequest req) {
    if (r.getStatusCode() == 200 ) {
    
        return r.getbody();
    }
    else {
        return 'ERROR: ' + r.getStatus();
    }
}

public String webdiacalloutresponse (String Method, String EndpathLogin, String EndPathReport ) {
   HttpRequest req = createRequest(Method, EndpathLogin);
   system.debug('Login' + EndpathLogin);
   HttpResponse resp = execute(req);
   
   //Can only execute if we're live
   if(!test.isrunningtest() ) {
   
    system.debug('First Body' + getResponseBody(resp, req));
  
   
   system.debug('Header' + resp.getheader('Set-Cookie'));
   req.setheader('Cookie', resp.getheader('Set-Cookie') ); 
   }
   system.debug('##E' + EndPathReport);
   req.setEndpoint(EndPathReport);
   req.setTimeout(90000);
   resp = execute(req);
   return getResponseBody(resp, req);
}



}