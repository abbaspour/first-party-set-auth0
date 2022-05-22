import {CloudFrontResponseEvent, CloudFrontResponseHandler, Context, CloudFrontResponse} from 'aws-lambda';

// https://auth0.com/docs/manage-users/cookies/authentication-api-cookies
const auth0CookiesRegEx = /^(auth0|auth0_compat|auth0-mf|auth0-mf_compat|did|did_compat)=/;

/**
 * Adds security headers to a response.
 */
export const handler: CloudFrontResponseHandler = async (event: CloudFrontResponseEvent, _: Context): Promise<CloudFrontResponse> => {

    // Get contents of response
    const response = event.Records[0].cf.response;
    const headers = response.headers;

    //console.log('inside edge function. headers: ', headers);
    const setCookies = headers["set-cookie"] || [];

    for (const sc of setCookies) {
        if(sc.key === 'Set-Cookie' && sc.value.match(auth0CookiesRegEx)) sc.value += '; SameParty';
    }

    console.log(setCookies);

    // Set new headers
    headers['x-from-edge'] = [{key: 'X-From-Edge', value: 'Amin Typescript async'}];
    headers['x-lambda-region'] = [ { key: 'X-Lambda-Region', value: process.env.AWS_REGION || 'unknown' } ];

    return response;
};
