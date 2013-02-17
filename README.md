# QAPreferences

QAPreferences provides a wrapper around NSUserDefaults in order to offer an easy and quick way to set up application in development mode.
The idea is to subclass QAPreferences and declare properties with same name as an identifier in Settings.bundle. QAPreferences will generate automatically a getter and setter.

# FEATURES
 - Generation of getter/setter for each property

# INSTALL
 - Extract a tarball or zipball of the repository into your project directory.
 - Add 'QAPreferences/QAPreferences.xcodeproj' as a subproject in your workspace.
 - Add libQAPreferences.a to 'Link Binary With Libraries' phase of your test target.
 
# Principles
	By default, the getter will get a value in NSUserDefaults with a key equal to <propertyName>.
	
	If a value exists for key <property name>Override it will use this one instead.

# HOW-TO

## Update automatically application version in Settings.bundle
You just have to create a Title item in your Settings.bundle with these keys:
 - qaBundleShortVersion for build version,
 - qaBundleVersion for version.
 
## Create a property to access Settings.bundle item
First, import QAPreferences category header.

	#import <QAPreferences/QAPreferences.h>

Then, subclass QAPreferences

	@interface RGNetworkConfigurator : QAPreferences

Finally, declare a property with an identifier from Settings.bundle.
	
	@property (nonatomic) NSNumber *shouldForceResetAtStartup;

## Set up defaults values
	You just have to provide a dictionary with default values by overriding - (NSString *)defaultValues method.
	
# LICENSE
Copyright (c) 2013 Quentin Arnault

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# CREDITS
This project is brought to you by Quentin Arnault and is under MIT License.

# TODO LIST
 - find a way to generate Settings.bundle,
 - find a way to use default values define in Settings.bundle,
 - add support for properties with non-object types,
 - add logs to have some feeback:
 	- default value for a property is not provided,
 	- identifier is not present in Settings.bundle.
 - ...
 
 Feel free to suggest some cool features.