import {CloudFrontResponseEvent, CloudFrontResponseHandler, Context, CloudFrontResponse/*CloudFrontResponseCallback, CloudFrontResponseResult,*/} from 'aws-lambda';

/**
 * Adds security headers to a response.
 */
export const handler: CloudFrontResponseHandler = async (event: CloudFrontResponseEvent, _: Context): Promise<CloudFrontResponse> => {

    console.log('inside edge function');

    // Get contents of response
    const response = event.Records[0].cf.response;
    const headers = response.headers;

    // Set new headers
    headers['strict-transport-security'] = [{
        key: 'Strict-Transport-Security',
        value: 'max-age= 63072000; includeSubdomains; preload'
    }];
    headers['content-security-policy'] = [{
        key: 'Content-Security-Policy',
        value: "default-src 'self' cdnjs.cloudflare.com style-src 'self' 'unsafe-inline';"
    }];
    headers['x-frame-options'] = [{key: 'X-Frame-Options', value: 'DENY'}];
    headers['x-xss-protection'] = [{key: 'X-XSS-Protection', value: '1; mode=block'}];
    headers['referrer-policy'] = [{key: 'Referrer-Policy', value: 'same-origin'}];

    headers['x-from-edge'] = [{key: 'X-From-Edge', value: 'Amin Typescript async'}];

    return response;
};
