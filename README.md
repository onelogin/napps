# OneLogin NAPPS SDKs

In this repository you'll find the SDKs and example projects that will help you integrate OneLogin's NAPPS to your application.

## Components


- On the Android and iOS directories you’ll find:

	1. `/Demos`: This directory contains example projects that demonstrate how you can integrate NAPPS to your own application.

		- Signal: The client side application.
		- Test Token Agent: A slimmed-down version of our Token Agent. The Test Token Agent has the exact same interface as the real Token Agent. This way you can test the integration without actually communicating with the OneLogin NAPPS service.

	2. `/SDK`: This directory contains the `.framework` (iOS) or `.jar` (Android) that you need to add to your project.

	3. `Reference.pdf`: This is a detailed guide on how to add the NAPPS SDKs to your native project.

- On the PhoneGap directory you’ll find:
	1. `/Demos`: This directory contains example projects that demonstrate how you can integrate NAPPS to your own PhoneGap application, either on iOS or Android (coming soon).

**Attention:** The PhoneGap example projects can be used with the native Test Token Agents on each platform.

- On the Server directory you’ll find:
	1. `OneLogin NAPPs Server Reference.pdf`: This document will help  you set up the server-side part of your application that will use NAPPs.