import tensorspark.example.spark_mnist as mnist
#from pyspark import SparkContext
#sc = SparkContext("spark://localhost:7077","spark_mnist",sparkHome="/opt/spark-2.0")
mnist.train(sc=sc, user='root', name='spark_mnist', server_host='${NAMENODE}', server_port=10080, sync_interval=100, batch_size=100, num_partition=1, num_epoch=2)