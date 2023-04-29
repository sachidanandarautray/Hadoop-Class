############################################
Hadoop setup
############################################

Oracle Virtual Box - https://www.virtualbox.org/wiki/Downloads 
Ubuntu Desktop LTS - https://ubuntu.com/download/desktop 
Setup parameters - 


# Ip address
ifconfig
sudo apt update 

# Java
sudo apt install openjdk-8-jdk
ls /usr/lib/jvm/java-8-openjdk-amd64
nano ~/.bashrc
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin
source .bashrc
echo $JAVA_HOME
java -version #1.8

# Passwordless ssh
ssh localhost
sudo apt-get install openssh-server openssh-client
ssh localhost
ssh-keygen -t rsa -P ""
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
ssh localhost
exit

# Hadoop
mkdir -p course/softwares
cd course/softwares
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz 
mv hadoop-3.3.4.tar.gz course/softwares
tar -xzvf hadoop-3.3.4.tar.gz

'''
Local (or Standalone) mode: There are no daemons and everything runs on a single JVM.
Pseudo-Distributed mode: Each daemon(Namenode, Datanode etc) runs on its own JVM on a single host.
Distributed mode: Each Daemon run on its own JVM across a cluster of hosts
'''

# Stand alone mode
ls
nano ~/.bashrc
export HADOOP_HOME=$HOME/Desktop/trialrun/softwares/hadoop-3.3.4
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
source .bashrc
hadoop version

# Word count problem in standalone mode
ls $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.4.jar

mkdir wordcountex 
# add text files inside that folder or cp $HADOOP_HOME/*.txt wordcountex
jar tf $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.4.jar | grep wordcount -i
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.4.jar  wordcount wordcountex texts_output 
cat texts_output/part-r-00000 | sort -k 2 -nr | head n -5

# Pseudo Distributed mode
nano ~/.bashrc

export HADOOP_HOME=$HOME/Desktop/trialrun/softwares/hadoop-3.3.4
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export HADOOP_HDFS_HOME=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"
export HADOOP_OPTS="-Djava.library.path=$HADOOP_COMMON_LIB_NATIVE_DIR"
export HADOOP_SECURITY_CONF_DIR

source ~/.bashrc

hadoop version
cd $HADOOP_HOME/etc/hadoop

nano hadoop-env.sh 
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

nano core-site.xml
<configuration>

   <property> 
      <name>fs.default.name</name> 
      <value>hdfs://localhost:9000</value> 
   </property>
   
</configuration>

nano hdfs-site.xml
<configuration>

   <property> 
      <name>dfs.replication</name> 
      <value>1</value> 
   </property> 
   <property> 
      <name>dfs.name.dir</name> 
      <value>file:///home/srividya/hadoopinfra/hdfs/namenode </value> 
   </property> 
   <property> 
      <name>dfs.data.dir</name>
      <value>file:///home/srividya/hadoopinfra/hdfs/datanode </value > 
   </property>
   
</configuration>

nano yarn-site.xml
<configuration>

   <property> 
      <name>yarn.nodemanager.aux-services</name> 
      <value>mapreduce_shuffle</value> 
   </property>
   
</configuration>

nano mapred-site.xml
<configuration>

   <property> 
      <name>mapreduce.framework.name</name> 
      <value>yarn</value> 
   </property>

</configuration>

cd ~
hdfs namenode -format
start-dfs.sh
start-yarn.sh

# Port to access Hadoop
http://localhost:9870/
http://localhost:8088/

stop-yarn.sh
stop-dfs.sh


# Word count problem in psuedo distributed mode
ls $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.4.jar
mkdir wordcountex 
# add text files inside that folder or cp $HADOOP_HOME/*.txt wordcountex
jar tf $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.4.jar | grep wordcount -i
# add files to hdfs 
hdfs dfs -mkdir /user/vidyahdfs
hdfs dfs -put wordcountex/*.txt /user/vidyahdfs

# run wc from hdfs files and save into hdfs
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.4.jar  wordcount vidyahdfs texts_output 
cat texts_output/part-r-00000 | sort -k 2 -nr | head n -5









#######PIG 


vboxuser@sachi:~/Desktop/course/softwares/hive$ cd
vboxuser@sachi:~$ pig
2023-04-21 23:34:16,430 INFO pig.ExecTypeProvider: Trying ExecType : LOCAL
2023-04-21 23:34:16,432 INFO pig.ExecTypeProvider: Trying ExecType : MAPREDUCE
2023-04-21 23:34:16,432 INFO pig.ExecTypeProvider: Picked MAPREDUCE as the ExecType
2023-04-21 23:34:16,521 [main] INFO  org.apache.pig.Main - Apache Pig version 0.17.0 (r1797386) compiled Jun 02 2017, 15:41:58
2023-04-21 23:34:16,521 [main] INFO  org.apache.pig.Main - Logging error messages to: /home/vboxuser/pig_1682100256507.log
2023-04-21 23:34:16,559 [main] INFO  org.apache.pig.impl.util.Utils - Default bootup file /home/vboxuser/.pigbootup not found
2023-04-21 23:34:16,831 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - mapred.job.tracker is deprecated. Instead, use mapreduce.jobtracker.address
2023-04-21 23:34:16,832 [main] INFO  org.apache.pig.backend.hadoop.executionengine.HExecutionEngine - Connecting to hadoop file system at: hdfs://localhost:9000
2023-04-21 23:34:17,302 [main] INFO  org.apache.pig.PigServer - Pig Script ID for the session: PIG-default-7b2ddbe3-de1b-41de-b669-43146d8d837d
2023-04-21 23:34:17,302 [main] WARN  org.apache.pig.PigServer - ATS is disabled since yarn.timeline-service.enabled set to false
grunt> describe dfA;
2023-04-21 23:35:24,291 [main] ERROR org.apache.pig.tools.grunt.Grunt - ERROR 1003: Unable to find an operator for alias dfA
Details at logfile: /home/vboxuser/pig_1682100256507.log
grunt> pwd
hdfs://localhost:9000/user/vboxuser
grunt> dump dfA;
2023-04-21 23:36:14,412 [main] ERROR org.apache.pig.tools.grunt.Grunt - ERROR 1003: Unable to find an operator for alias dfA
Details at logfile: /home/vboxuser/pig_1682100256507.log
grunt> dfA = load '/user/data/empdata.csv' using PigStorage(',') as ( id:int, name:chararray, sal:int, dpno:int);
grunt> describe dfA;
dfA: {id: int,name: chararray,sal: int,dpno: int}
grunt> dump dfA;




2023-04-21 23:40:00,937 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil - Total input paths to process : 1
(,ename,,)
(1,sachi,1000,233)
(2,karan,20000,788)
(3,amanbara,20000,900)
(4,amanchha,6000,899)
(5,catherine,89999,987)
grunt> 





grunt> describe dfA;
dfA: {id: int,name: chararray,sal: int,dpno: int}
grunt> dfC = filter dfA by sal>=80000;
grunt> dump dfC;


2023-04-21 23:48:31,779 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil - Total input paths to process : 1
(5,catherine,89999,987)
grunt> 



grunt> describe dfA;
dfA: {id: int,name: chararray,sal: int,dpno: int}
grunt> emp_foreach = foreach dfA generate name,sal;
dump emp_foreach;



2023-04-22 00:10:32,225 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil - Total input paths to process : 1
(ename,)
(sachi,1000)
(karan,20000)
(amanbara,20000)
(amanchha,6000)
(catherine,89999)

grunt> describe dfA;
dfA: {id: int,name: chararray,sal: int,dpno: int}
grunt> emp_order = order dfA by sal desc;
grunt> dump emp_order;

2023-04-22 00:25:15,764 [main] INFO  org.apache.pig.backend.hadoop.executionengine.util.MapRedUtil - Total input paths to process : 1
(5,catherine,89999,987)
(3,amanbara,20000,900)
(2,karan,20000,788)
(4,amanchha,6000,899)
(1,sachi,1000,233)
(,ename,,)


