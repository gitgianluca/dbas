Oracle Database 11g Release 11.2.0.4.0

OPTIMIZER Patch for Bug# 18747342 for Solaris-64 Platforms
   
This patch is RAC Rolling Installable. 

This patch is Online Patchable - Please read My Oracle Support note 761111.1 on how to use/deploy an online patch

This patch is Data Guard Standby-First Installable. Please  read My Oracle Support Note 1265700.1 https://support.us.oracle.com/oip/faces/secure/km/DocumentDisplay.jspx?id=1265700.1
Oracle Patch Assurance - Data Guard Standby-First Patch Apply for details on how to remove risk and reduce downtime when applying this patch.

Released: Mon Jul 13 16:25:00 2015

This document describes how you can install the OPTIMIZER combo patch for bug#  18747342 on your Oracle Database 11g Release 11.2.0.4.0.

A combo patch is a patch that can be applied either in offline mode or in online mode. For information about offline and online modes of patching, see My Oracle Support note 761111.1 available at:
https://support.oracle.com/CSP/main/article?cmd=show&type=NOT&id=761111.1

Note:
- Online patches are recommended when a downtime cannot be scheduled and the patch needs to be applied urgently.

- Online patches consume additional memory and if kept permanently the memory consumption increases as the number of processes in the system increases.

- It is strongly recommended to rollback all Online patches and replace them with regular (offline) patches on next instance shutdown or the earliest maintenance window.

 
(1) Prerequisites
------------------
Before you install or deinstall the patch, ensure that you meet the following requirements:

Note: In case of an Oracle RAC environment, meet these prerequisites on each of the nodes.

1.	Ensure that the Oracle home on which you are installing the patch or from which you are rolling back the patch is Oracle Database 11g Release (11.2.0.4.0).

2.	Oracle recommends you to use the latest version of OPatch available for 11g Release 11.2.0.4.0. If you do not have OPatch 11g Release 11.2.0.4.0 or the latest version available for XXg Release X, then download it from patch# 6880880 for 11.2.0.4.0 release.
	
	For information about OPatch documentation, including any known issues, see My Oracle Support Document 293369.1 OPatch documentation list:
	https://support.oracle.com/CSP/main/article?cmd=show&type=NOT&id=224346.1 


3.	Ensure that you set (as the home user) the ORACLE_HOME environment variable to the Oracle home.


4.	Ensure that the $PATH definition has the following executables: make, ar, ld and nm. The location of these executables depends on your operating system. On many operating systems, they are located in /usr/ccs/bin.


5.	Ensure that you verify the Oracle Inventory because OPatch accesses it to install the patches. To verify the inventory, run the following command. If the command displays some errors, then contact Oracle Support and resolve the issue.
	$ opatch lsinventory 

	Note:
	-	If this command succeeds, it will list the Top-Level Oracle Products and one-off patches if any that are installed in the Oralce Home.
			- Save the output so you have the status prior to the patch apply.
	-	If the command displays some errors, then contact Oracle Support and resolve the issue first before proceeding further.


6.	(Only for Installation) Maintain a location for storing the contents of the patch ZIP file. In the rest of the document, this location (absolute path) is referred to as <PATCH_TOP_DIR>. Extract the contents of the patch ZIP file to the location (PATCH_TOP_DIR) you have created above. To do so, run the following command:
	$ unzip -d <PATCH_TOP_DIR> p18747342_112040_SOLARIS64.zip  


7.	(Only for Installation) Determine whether any currently installed interim patches conflict with this patch 18747342 as shown below:
	$ cd <PATCH_TOP_DIR>/18747342
	$ opatch prereq CheckConflictAgainstOHWithDetail -ph ./
	
	The report will indicate the patches that conflict with this patch and the patches for which the current 18747342 is a superset.
	
	Note:
	When OPatch starts, it validates the patch and ensures that there are no conflicts with the software already installed in the ORACLE_HOME. OPatch categorizes conflicts into the following types: 
	-	Conflicts with a patch already applied to the ORACLE_HOME that is a subset of the patch you are trying to apply  - In this case, continue with the patch installation because the new patch contains all the fixes from the existing patch in the ORACLE_HOME. The subset patch will automatically be rolled back prior to the installation of the new patch.
	-	Conflicts with a patch already applied to the ORACLE_HOME - In this case, stop the patch installation and contact Oracle Support Services.


8.	(Only for Offline Patching) Ensure that you shut down all the services running from the Oracle home.
	Note:
	-	For a Non-RAC environment, shut down all databases and listeners associated with the Oracle home that you are updating. For more information, see Oracle Database Administrator's Guide.
	-	For a RAC environment, shut down all the services (database, ASM, listeners, nodeapps, and CRS daemons) running from the Oracle home of the node you want to patch. After you patch this node, start the services on this node. Repeat this process for each of the other nodes of the Oracle RAC system. OPatch is used on only one node at a time.


9.	(Only for Online Patching) Ensure that all the services in the Oracle home are up and running.

10.	(Only for Online Patching) Ensure that you maintain adequate memory on your system to apply this online patch. To calculate the amount of memory required for this online patch, use the following formula:
	Memory Consumed = (Number of Oracle Processes + 1) X (Size of Patched .pch File) 

	Note:
	-	For UNIX, the number of Oracle processes is determined by checking the parameter "processes" in the database by querying v$parameter. For Microsoft Windows, the number of Oracle processes is always zero (0).
	-	The .pch file is available under <bug_number>/online/files/hpatch/ directory.

(2) Installation
-----------------
This section describes the following modes you can use to install the combo patch. Use the one that best suits your requirement. 
-	Installing in Offline Mode
-	Installing in Online Mode

(2.1) Installing in Offline Mode
-----------------------------------
To install the patch, follow these steps:

1.	Set your current directory to the directory where the patch is located and then run the OPatch utility by entering the following commands:
	
	$ cd <PATCH_TOP_DIR>/18747342

	$ opatch apply

2.	Verify whether the patch has been successfully installed by running the following command:

	$ opatch lsinventory

3.	Start the services from the Oracle home.

(2.2) Installing in Online Mode
-----------------------------------
To  install the patch in online mode, follow these steps:

1.	Set your current directory to the directory where the patch is located and then run the OPatch utility by entering the following commands:
	
	$ cd <PATCH_TOP_DIR>/18747342

2.	Install the patch by running the following command:
	-	For Non-RAC Environments (Standalone Databases):  
		$ opatch apply online -connectString <SID>:<USERNAME>:<PASSWORD>: 
	-	For RAC Environments: 
		$ opatch apply online -connectString <SID_Node1>:<Username_Node1>:<Password_Node1>:<Node1_Name>,<SID_Node2>:<Username_Node2>:<Password_Node2>:<Node2_Name>,<SID_NodeN>:<Username_NodeN>:<Password_NodeN>:<NodeN_Name>

	Note:
	-	Run the previous command on the first node of the Oracle RAC system, and specify details of each node separated by a comma. In the command, NodeN refers to the different nodes of the Oracle RAC system. Once the patch is applied on the first node, OPatch automatically moves over and patches the next node you have specified in the comamnd. 


(3) Deinstallation
--------------------
This section describes the following modes you can use to deinstall the combo patch. Use the one that best suits your requirement. 
-	Deinstalling in Offline Mode
-	Deinstalling in Online Mode

(3.1) Deinstalling in Offline Mode
-------------------------------------
Ensure to follow the Prerequsites (Section 1). To deinstall the patch, follow these steps:

1.	Deinstall the patch by running the following command:
	
	$ opatch rollback -id 18747342

2.	Start the services from the Oracle home.

3. 	Ensure that you verify the Oracle Inventory and compare the output with the one run before the patch installation and re-apply any patches that were rolled back as part of this patch apply. To verify the inventory, run the following command:

	$ opatch lsinventory

(3.2) Deinstalling in Online Mode
--------------------------------------
Ensure to follow the Prerequsites (Section 1). To deinstall the patch in online mode, follow these steps:

1.	Deinstall the patch by running the following command:
	-	For Non-RAC Environments (Standalone Databases):  
		$ opatch rollback -id 18747342 -connectString <SID>:<USERNAME>:<PASSWORD>:
	-	For RAC Environments: 
		$ opatch rollback -id 18747342 -connectString <SID_Node1>:<Username_Node1>:<Password_Node1>:<Node1_Name>,<SID_Node2>:<Username_Node2>:<Password_Node2>:<Node2_Name>,<SID_NodeN>:<Username_NodeN>:<Password_NodeN>:<NodeN_Name>

	Note:
	Run the previous command on the first node of the Oracle RAC system, and specify details of each node separated by a comma. In the command, NODEn refers to the different nodes of the 
	Oracle RAC system. Once the patch is rolled back from the first node, OPatch automatically moves over and rolls back the patch from the next node you have specified in the comamnd. 

(4) Bugs Fixed by This Patch
---------------------------------
The following are the bugs fixed by this patch:
  18747342: PLAN REPRODUCTION FAILS WITH MERGE STATEMENT AND SELECT LIST SUBQUERIES


--------------------------------------------------------------------------
Copyright 2015, Oracle and/or its affiliates. All rights reserved.  
--------------------------------------------------------------------------
