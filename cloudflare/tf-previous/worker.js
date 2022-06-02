addEventListener('fetch', event => {
    event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {
    request = new Request(request)
    request.headers.set('cname-api-key', `${CNAME_API_KEY}`)
    return await fetch(request)
}
