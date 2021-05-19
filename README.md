# Mongo DB API DART

## Overview

In partnership with [Firebase](https://firebase.google.com/), we're making the public Hacker News data available in near real time. Firebase enables easy access from [Android](https://firebase.google.com/docs/android/setup), [iOS](https://firebase.google.com/docs/ios/setup) and the [web](https://firebase.google.com/docs/web/setup). [Servers](https://firebase.google.com/docs/server/setup) aren't left out.

If you can use one of the many [Firebase client libraries](https://firebase.google.com/docs/libraries/), you really should. The libraries handle networking efficiently and can raise events when things change. Be sure to check them out.

Please email api@ycombinator.com if you find any bugs.

## URI and Versioning

We hope to improve the API over time. The changes won't always be backward compatible, so we're going to use versioning. This first iteration will have URIs prefixed with `https://hacker-news.firebaseio.com/v0/` and is structured as described below. There is currently no rate limit.

For versioning purposes, only removal of a non-optional field or alteration of an existing field will be considered incompatible changes. *Clients should gracefully handle additional fields they don't expect, and simply ignore them.*

## Design

The v0 API is essentially a dump of our in-memory data structures. We know, what works great locally in memory isn't so hot over the network. Many of the awkward things are just the way HN works internally. Want to know the total number of comments on an article? Traverse the tree and count. Want to know the children of an item? Load the item and get their IDs, then load them. The newest page? Starts at item maxid and walks backward, keeping only the top level stories. Same for Ask, Show, etc.

I'm not saying this to defend it - It's not the ideal public API, but it's the one we could release in the time we had. While awkward, it's possible to implement most of HN using it.

## GetData

Stories, comments, jobs, Ask HNs and even polls are just items. They're identified by their ids, which are unique integers, and live under `/GetData`.

All items have some of the following properties, with required properties in bold:

Headers | Description
------|------------
**loginDb** | The item's unique id.
senhaDb | `true` if the item is deleted.
clusterDb | The type of item. One of "job", "story", "comment", "poll", or "pollopt".
formatDb | The username of the item's author.
hostDb | Creation date of the item, in [Unix Time](http://en.wikipedia.org/wiki/Unix_time).
loginDb | The comment, story or poll text. HTML.
selector | opcional
login | 
senha |
tabela |
descendants | In the case of stories or polls, the total comment count.

For example, a story: https://hacker-news.firebaseio.com/v0/item/8863.json?print=pretty

```javascript
{
  "by" : "dhouston",
  "descendants" : 71,
  "id" : 8863,
  "kids" : [ 8952, 9224, 8917, 8884, 8887, 8943, 8869, 8958, 9005, 9671, 8940, 9067, 8908, 9055, 8865, 8881, 8872, 8873, 8955, 10403, 8903, 8928, 9125, 8998, 8901, 8902, 8907, 8894, 8878, 8870, 8980, 8934, 8876 ],
  "score" : 111,
  "time" : 1175714200,
  "title" : "My YC app: Dropbox - Throw away your USB drive",
  "type" : "story",
  "url" : "http://www.getdropbox.com/u/2/screencast.html"
}
