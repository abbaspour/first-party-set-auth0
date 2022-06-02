addEventListener("fetch", (event) => {
	event.respondWith(handleRequest(event.request));
});

async function handleRequest(request) {
	// constants
	const RESPONSE_HEADER_COOKIE = "Set-Cookie";
	const COOKIE_FLAG_SAMEPARTY = "SameParty";
	const REQUEST_HEADER_API_KEY = "cname-api-key";

	// dirty cookie parser and setter :(
	// fetch API response.headers.get sucks - especially for 'set-cookie'
	// there is apparently no way to get an array of cookies (only a dirty string with all cookies)
	// also, npm cookie package does not parse that string properly :(
	// here is the official 'issue' https://github.com/node-fetch/node-fetch/issues/251
	let dirtyCookieParserAndSetter = (cookieString) => {
		const delim = ", ";
		const splits = cookieString.split(delim);
		response.headers.delete(RESPONSE_HEADER_COOKIE);
		for (let i = 0; i < splits.length; i++)
			response.headers.append(
				"set-cookie",
				`${splits[i]}${delim}${splits[++i]}; ${COOKIE_FLAG_SAMEPARTY}`
			);
	};

	// init Request object
	request = new Request(request);

	// URL to auth0 edge record
	var url = new URL(request.url);

	// alternative way to rewrite the host header
	url.hostname = AUTH0_EDGE_RECORD;

	// add auth0 secret
	request.headers.set(REQUEST_HEADER_API_KEY, AUTH0_CNAME_API_KEY);

	// request to origin
	let response = await fetch(url, request);

	// init Response object
	response = new Response(response.body, response);

	// response cookies
	let dirtyCookieString = response.headers.get(RESPONSE_HEADER_COOKIE);
	if (dirtyCookieString) {
		// stamp the SameParty flag on each cookie
		dirtyCookieParserAndSetter(dirtyCookieString);
	}

	// response to viewer
	return response;
}
