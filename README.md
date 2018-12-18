# CVProjectVideoAvatar
Project of SJTU SE 2018 fall Computer Vision course. Based on thmoa/videoavatars.

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

## Team
This is a teamwork of a 4-member team, all members are from SE-SJTU  
Name and ID are listed below

	Chen Zhiyang	516030910347
	Zhao Ying	516030910422
	Wang Weixi	516030910463
  
  
