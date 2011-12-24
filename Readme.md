# Iridia Streamer

Cappuccino + Twitter + UStream.  Evadne Wu @ Iridia Productions, 2011.

## Developing

* [Bootstrap Cappuccino](http://cappuccino.org/download/) so you can work on the main application and fill-in the Frameworks.

* Install [Adobe Flex SDK](http://opensource.adobe.com/wiki/display/flexsdk/Download+Flex+4.5) so you can work with the part of the app that talks with UStream’s RSL API.

* Get your own UStream API key.


###	Notes for local development

Since the app makes cross-origin calls, you should run the application thru a Web server at all times; the Web Sharing feature in OS X wraps around Apache and you can use it.


## Deploying

Since the app is mostly just static, you can deploy it on Amazon S3.  Actually, any server will do.

### Deploying on Amazon S3

Let’s leave the fiddling out of the documentation, but you’ll need a bucket policy that allows **everyone** readonly access to everything in the bucket for it to work.

Plug: If you haven’t done so, go get [Transmit](http://panic.com/transmit/) and life with buckets will be much more easier!

#### Sample bucket policy

	{
	  "Version":"2008-10-17",
	  "Statement":[{
		"Sid":"PublicReadGetObject",
	        "Effect":"Allow",
		  "Principal": {
	            "AWS": "*"
	         },
	      "Action":["s3:GetObject"],
	      "Resource":["arn:aws:s3:::example-bucket/*"
	      ]
	    }
	  ]
	}


## FAQ

### Video is not showing up in the app, but it works on UStream

Various causes:

* The RSL API provided by UStream changed
* You’re running the app locally, leaving the Flash runtime violating Sandbox Access
