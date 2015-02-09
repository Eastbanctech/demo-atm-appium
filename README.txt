To install cucumber test environment you need to do following steps:

First run:
	Go to appium folder
	$ cd appium/
	Run script to install all environment
	
	$ sh setup.sh
	
	Return to project folder 
	$ cd ..
	
	
If you had problems with appium installing go to http://appium.io and download application. Open it and install like rest of other OSX apps.

After installation run Appium.app
OR if you've installed it from sources(npm, git) run from console:
	
	$ appium &

Select iOS as target and Launch server

If you are running this first time, please execute run.sh script in root project folder to build application
If not you can just run
	$ cucumber appium/