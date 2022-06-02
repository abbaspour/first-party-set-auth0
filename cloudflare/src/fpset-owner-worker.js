addEventListener("fetch", (event) => {
	event.respondWith(handleRequest(event.request));
});

async function handleRequest(request) {
	return new Response(jsonBody, {
		headers: { "content-type": "application/json" },
	});
}

let jsonBody = `{
    "owner": ${FPSET_OWNER_DOMAIN},
    "members": ${FPSET_MEMBER_DOMAINS_JSON_ARRAY}
  }`;
