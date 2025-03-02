package com.example

import org.apache.flink.streaming.api.scala._
import org.apache.flink.streaming.api.TimeCharacteristic
import org.apache.flink.streaming.api.windowing.time.Time

object ExampleJob {
  def main(args: Array[String]): Unit = {
    // Set up the execution environment
    val env = StreamExecutionEnvironment.getExecutionEnvironment

    // Set the time characteristic to Processing Time
    env.setStreamTimeCharacteristic(TimeCharacteristic.ProcessingTime)

    // Create a DataStream of integers that continuously emits numbers
    val stream = env.fromSequence(1, Long.MaxValue)
      .map(n => (n, 1))
      .keyBy(_._1 % 10) // Group by the last digit
      .timeWindow(Time.seconds(1))
      .sum(1)

    // Print the result to stdout
    stream.print()

    // Execute the job
    env.execute("Continuous Flink Streaming Job")
  }
}