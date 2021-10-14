---
title: "DNS explanation"
date: 2017-11-01T10:49:22+03:00
tags: ["linux", "dns"]
---

## What is DNS?

DNS is an acronym of Domain Name System and it’s widely used in different mediums. As the name suggests, DNS is a naming system that gives a name to any computer or service connected to a network. DNS is utterly important and everyone should use it. Without it, we’d have to visit websites through their IP addresses, rather than their domain. So, for example, if you wanted to visit our website through it’s IP address, you’d have to go to 209.135.140.30. But with DNS, you can go to rosehosting.com . It’s easier to remember and it’s more user-friendly. That’s why people consider DNS “the phone book of the Internet”. Nobody wants to remember an IP, but everyone can and does remember a domain name.

## How does DNS work?

There’s lots of stuff going on “behind the scenes” when you visit a website. There’s a communicating relationship between a few servers and your computer. These are the usual steps they take:

1. **The user enters the website’s domain in the address bar**
The DNS translation process stars when a user types in a domain name/address in the URL bar of his web browser. With that, the user essentially requests the IP address of the domain and waits for a response.

2. **The browser and OS check their local cache**
After a user requests information on a domain, the user’s OS and browser check their local cache for any information on that domain. If the domain is already in the cache, the browser returns a positive response, if not, the Resolver needs to be contacted.

3. **The Resolver checks the local cache**
In most cases, the resolver is actually your ISP. First, the resolver checks to see if there’s any local data available. If not, he contacts the domain’s root server. What is a root server you ask?
Well, a root server is a name server that covers the root zone of the Internet’s Domain Name System (DNS). It answers requests for records in the root DNS zone among other requests. For example if a request is received and asks what are the authoritative name servers for rosehosting.com it will return the authoritative name servers for the respective top-level domain (TLD). The root name servers are the first step in resolving human readable host names into IP addresses thus making them a critical part of the Internet infrastructure. There are thirteen root nameservers specified in the world. But don’t let this information scare you. It does not mean that there are only thirteen existing physical servers. They each have redundant equipment in place that provides reliable service even if failure of hardware or software occurs. Additionally, the root name servers operate in multiple geographical locations that use a routing technique called anycast addressing. Wikipedia’s definition for anycast addressing is: a network addressing and routing methodology in which datagrams from a single sender are routed to the topologically nearest node in a group of potential receivers, though it may be sent to several nodes, all identified by the same destination address.

4. **The root server checks the local cache**
After a request is received for a domain, the domain’s root server checks the local cache for any information about the respective domain. If there is such, it responds with the IP, if not it points the resolver to the TLD server. The modus operandi of the root nameserver involves looking at the first part of the request, reading from right to left. So let’s use our website as an example again. In this case the root nameserver checks the request for rosehosting.com, sees that the TLD is com and forwards the query to the respective TLD nameservers.

5. **The root server forwards the resolver to the TLD server**
The TLD nameservers review the next part of the request (rosehosting) and directs the inquiry to the nameservers responsible for rosehosting.com which are called authoritative DNS servers. These authoritative DNS servers contain all the information about RoseHosting.com stored in DNS records. There are many types of records with each carrying a different kind of information. For example, if we want to know the IP address for google.com we need to know the A record for the domain.

Below is a list of some of the available DNS records which in general are mostly used:

* **A** record – the address record which links a domain to the physical IP address of the server that will host the domain
* **CNAME** record: the Canonical Name record points an alias name to another domain name. For example, www.rosehosting.com might link www.rosehosting.com to rosehosting.com where **www** is the actual CNAME.
* **MX** record: mail exchange (MX) records serve to direct the domain’s email to the server that hosts the email user accounts. The MX record specifies the mail server responsible for accepting email messages on behalf of the recipient domain.
* **NS** record: Name server records determine which servers are authoritative for a particular domain which means that the DNS servers set as authoritative for the domain will be responsible for communicating DNS information.
* **TXT** record: this record provides text information with a host or other name about a server, network, data center etc… to sources outside your domain.
* **TTL** record: TTL (Time To Live) is a value in a DNS record that specifies the maximum amount of time other DNS servers and applications should cache the record.

With this short info on the DNS records out of our way, we can now continue with the article. Where were we? Ahh, yes.

The resolver now retrieves the A record for rosehosting.com from the authoritative DNS servers. The record is now stored in it’s local cache so if anyone else requests to visit the RoseHosting website, the resolver or (as others call it) recursive server will already have the answer so it won’t have to go through the above explained lookup process again. Of course depending on the TTL record set for the domain, the recursive server will have to ask for a new copy of the record to make sure that the information is up to date.

6. **Receiving the answer**
The resolver now has the A record for rosehosting.com and returns the info back to your computer. Your machine stores the record in the respective cache, reads the IP address from the record and then passes the information to your web browser. The browser opens a connection with the web server of rosehosting.com, receives and then displays our website on your screen.

Even though this process seems like it’s time consuming, it only takes milliseconds to complete.

Obviously, with this article we just covered the DNS basics, so you might want to check various articles on the Internet such as the [Wikipedia DNS page](https://en.wikipedia.org/wiki/Domain_Name_System) or anything else you find.

