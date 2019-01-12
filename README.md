# CVProjectVideoAvatar
Project of SJTU SE 2018 fall Computer Vision course. Based on thmoa/videoavatars.


## Quick Start
For quick start, A docker image has been made and upload to docker hub.  
Everyone can use simple command to run this project without bordering environment configuration.  

	(Under Linux or OSX system)
	sudo docker pull kurotsuba/vaenv:latest
	git clone https://github.com/Kurotsuba/CVProjectVideoAvatar.git CVProj
	sudo docker run -it --privileged --cap-add=ALL -v /home/<your username>/CVProj:/home/test kurotsuba/vaenv:latest /bin/bash
	cd /home/test
Then you can run things like ./run_step1.sh directly.  

## Setup
Follow the guidance of [videoavatars](https://github.com/thmoa/videoavatars) almost step-by-step.  
PS: The videoavatars repository will be mentioned as *the repo*  

#### Step 1
Clone the repository from [videoavatars](https://github.com/thmoa/videoavatars)  

	cd
	mkdir CVProj
	git clone https://github.com/thmoa/videoavatars.git videoavatars

#### Step 2
Sign up to get SMPL module and SMPLify code.  
Although they both belong to is.tue.mpg.de, I have to sign up twice and get two different account.  
Use the password sent to mailbox to login, and download two zip file.  
Extract them under Linux environment.(only Linux and OSX are supported)  
They are in home/xxx/CVProj/smpl and home/xxx/CVProj/smplify_public  
Follow the guidance of *the repo*  

	cd vendor
	mkdir smpl
	cd smpl
	touch __init__.py
	ln -s home/xxx/CVProj/smpl/models .
	// The dot(.) at the end of the line is important
	ln -s home/xxx/CVProj/smpl/smpl_webuser/*.py .
	cd ..

	mkdir smplify
	cd smplify
	touch __init__.py
	ln -s home/xxx/CVProj/smplify_public/code/models .
	cp home/xxx/CVProj/smplify_public/code/lib/sphere_collisions.py .
	ln -s home/xxx/CVProj/smplify_public/code/lib/capsule_body.py .
	ln -s home/xxx/CVProj/smplify_public/code/lib/capsule_ch.py .
	ln -s home/xxx/CVProj/smplify_public/code/lib/robustifiers.py .
Then change line 18 of home/xxx/CVProj/videoavartars/vendor/sphere_collisions.py to  

	from vendor.smpl.lbs import verts_core  

#### Step 3
Setup the environment.  
*the repo* is written in python2, so if the python version is 3.x, python2 should be installed.  
According to requirement.txt in *the repo*, use pip to install packages below  

	opendr>=0.76
	numpy>=1.11.0
	scipy>=0.19.0
	matplotlib==2.*
	h5py==2.7.*
	tqdm==4.*
	chumpy>=0.67
opendr depends on the others except h5py, tqdm, chumpy. So pip will install many packages after  

	pip install opendr
Install command should be operated under root.  
During Installation of matplotlib, an error raised 

	fatal error: Python.h no such file or directory
This is because python-dev is not installed. python-tk will raise another error.  

	sudo apt-get install python-dev python-tk
After installation of those packages, run again

	pip install opendr
This time opendr will be installed successfully. Then install other packages(they can be installed before opendr, order doesn't care)

	pip install h5py
	pip install tqdm
	pip install chumpy
Then check if all dependencies are installed properly with

	pip list
Everything seems right.  

#### Step 4
Prepare the test dataset.
Download the dataset mentioned in *the repo*, extract them into /home/xxx/CVProj/people_snapshot_public  
Then create a directory to save result of the script  

	(current dir is /home/xxx/CVProj/)
	mkdir output
	cd videoavatars
	./run_step1.sh /home/xxx/CVProj/people_snapshot_public/female-1-casual output
Then wait for script to finish its job. This will take a long time(maybe 10 to 12 hours)  
Other two scripts are the same, but much faster.

#### Step 5
Try to make this repository more portable.  
Use copy to replace link, copy necessary files from smpl and smplify into this repository.  
Use

	./run_step2.sh
to test if the change is valid.  


## Move to Python3
Finally we succeeded in moving step2 and step3 to python3, they run with no error and give almost the same result as *the repo* Step1 cost too much time for debugging, at last we failed.

### 2 libraries
*the repo* has two depencies only available for python2, they are chumpy and opendr, while opendr depends on chumpy, so first I want to modify source code of chumpy, then opendr, then *the repo*.  
With pip, install depencies from local is easy with  

	sudo pip3 install <path>
Then it will run setup.py.  

#### Chumpy 
chumpy is based on scipy and numpy, so install these modules for python3, then modify _every file_ to suit the syntax of python3. Especially the _import_ and _print_. Python3 use absolute path for import, while python2 is relative. For tens of code modified, chumpy is able to install for python3. Notice this is only success of _install_.  

#### Opendr
opendr is more complicate then chumpy, it use cython to accelarate. In setup.py, a function called download_osmesa() use utils.wget(). utils.wget() use urllib to make http request and download the needed file. In python3, urllib has some change, so I replace it with urllib3. In context dir are some cython files, to run cython, python3-dev is needed. Also change the *Makefile* to support python3. After some other syntax error are fixed, opendr is successfully installed.  

### Code in *the repo*
First change _print_ and _import_ for 3 scripts, the try to run. Of course they will not work, because there are some changes in python3 which can lead to unsuspected action.  

#### bytes and string
In python2, bytes and string can be used as the same, although they are not the same class. But in python3, they are strictly seperated. This will lead to some bugs in cython script, because the C code do not ask for a string object but bytes, and the author of *the repo* pass a string into it. Convert some args to bytes with  

	bytes(str)
is enough.  
 
#### pickle
The module name change from cPickle to pickle, and the default codec is changed. I try to use iso-8859-1 to load the pickled model, luckily it works.  

#### missing command
Some command in python2 are removed or renamed in python3, such as _range_, _xrange_, _reduce_.  
For _reduce_, simply import it from _functools_ can solve the problem.  
For _range_ and _xrange_, they are renamed. range() in python2 returns a list object, while in python3 a range object (a kind of generator object). list object can be plus together, but generator object cannot. In those case, wrap range with a list(), convert them to a list. xrange() is renamed to range() in python3, so simply delete the 'x' can solve the problem.  

#### division
Division in python2 with single slash(/) between two int will return a int, same as in C. But in python3, it will return a float in case like 1/2. *the repo* use division to calculate index number in some place and pass it to opendr, In python3 this can cause use a numpy.float64 object as index, which is invalid. Also this change can lead to wrong result. I change every slash before a integer into double slash (//) which can return a int. At least for step2 and step3, it works. This change should also happen in the depencies for correct result.  

#### meaningless check for me
Step2 will check if tensorflow is on the machine, I know I have no tensorflow, so I delete the check to save time.  

#### type error(not solve yet)
Step1 multiplex or divide chumpy set object with integers. This can be allowed in python2, but not in python3. Currently I don't know how to fix this problem, maybe I need something to unpack the set and pack it after the operation.  

Another issue is the two success script didn't speed-up.

## Concurrency
As the GIL of python, the multithreading peformance is good only when there are lot of IO operation. So multiprocessing is the only way to implement meaningful concurrency.  

Step1 is hard to debug so we start with step2.  
Notice that step2 has 3 for-loop, 1 is inherited in another, so our target is on 2 loop. One is in main() to setup frames, another is in fix_concensus().  
The one in fix_concensus() cost most time of step2, so I decide to modify it first. It will loop for 3 times and cost about 50s each time on my machine. I use ProcessPollExecutor in concurrent.futures to create a process pool, pack the loop into a function and make the data into a arg tuple. 3 loop can run concurrently, and it does speed-up, but the problem is the result of calculation are missed. After hours of work, I found 3 loops have data dependency, which means this *cannot* be run concurrently.  
The loop of setup frames can be paralelled, but due to some reasons, the result modle has less hair but fatter. This problem has not been solve yet.

## Team
This is a teamwork of a 4-member team, all members are from SE-SJTU  
Name and ID are listed below

	Chen Zhiyang	516030910347
	Zhao Ying	516030910422
	Wang Weixi	516030910463
	Lin Yixuan	515030910302
  
  
