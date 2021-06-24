package com.example.recording

import android.util.Log
import androidx.annotation.NonNull
import com.example.recording.ml.PersonLiteModel
import com.example.recording.ml.ProjectorLiteModel
import com.example.recording.ml.WhiteboardLiteModel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.tensorflow.lite.DataType
import org.tensorflow.lite.support.image.TensorImage
import org.tensorflow.lite.support.tensorbuffer.TensorBuffer

class MainActivity: FlutterActivity() {
    private val CHANNEL = "SmartSlidesRecorder/YOLO"

    fun initPredictions(inputImage : DoubleArray) : DoubleArray{
        // init all models
        val projectModel = ProjectorLiteModel.newInstance(context)
        val whiteboardModel = WhiteboardLiteModel.newInstance(context)
        val personModel = PersonLiteModel.newInstance(context)

        // copy image input into tensor buffer
        val inputFeature = TensorBuffer.createFixedSize(intArrayOf(1, 416, 416, 3), DataType.FLOAT32)
        val tImage = TensorImage(DataType.FLOAT32)
        val floatArray = FloatArray(inputImage.size)
        Log.d("INPUT BUFFER",inputImage.size.toString());

        // convert double (which flutter serializer expect) to float (which TF except)
        for (i in inputImage.indices) {
            floatArray[i] = inputImage.get(i).toFloat()
        }

        tImage.load(floatArray, intArrayOf(1,416,416,3));
        inputFeature.loadBuffer(tImage.buffer)

        val outputs = inferFromYolo(inputFeature)
        val flattenList = mutableListOf<Double>()
        for (i in 0..2){
            for (j in 0..5) {
                flattenList.add(outputs[i][j])
            }
        }
        // convert List<Double> to doubleArray for serialization
        val flattenOutput = DoubleArray(3*6)
        for (i in flattenOutput.indices){
            flattenOutput[i] = flattenList[i]
        }
        projectModel.close()
        whiteboardModel.close()
        personModel.close()
        return flattenOutput

    }

    private fun inferFromYolo (inputTensor : TensorBuffer) : Array<DoubleArray>{
        val projectModel = ProjectorLiteModel.newInstance(context)
        val whiteboardModel = WhiteboardLiteModel.newInstance(context)
        val personModel = PersonLiteModel.newInstance(context)
        // create 3x6 for 3 models output
        val outputs = Array(3) {DoubleArray(6) {0.0} }
        // infer from projector
        val projectOutput = projectModel.process(inputTensor)
        outputs[0]  = getOutputFromYoloOutputBuffer(projectOutput.outputFeature0AsTensorBuffer.floatArray)

        // infer from whiteboard
        val whiteboardOutput = whiteboardModel.process(inputTensor)
        outputs[1]  = getOutputFromYoloOutputBuffer(whiteboardOutput.outputFeature0AsTensorBuffer.floatArray)

        // infer from Person
        val personOutput = personModel.process(inputTensor)
        outputs[2]  = getOutputFromYoloOutputBuffer(personOutput.outputFeature0AsTensorBuffer.floatArray)
        return outputs;

    }

    private fun getOutputFromYoloOutputBuffer (outputBuffer : FloatArray) : DoubleArray{
        Log.d("OUTPUT BUFFER SIZE",outputBuffer.size.toString());
        Log.d("OUTPUT BUFFER 2284",outputBuffer[2284].toString());

        var i = 0
        var maxIndex : Int = -1
        var maxScore : Float = 0F
        while (i < outputBuffer.size){
            val score = outputBuffer[i + 4] * outputBuffer[i + 5]

            if (score > 0.4 && score > maxScore){
                maxScore = score
                maxIndex = i
            }
            i+=6;
        }
//        Log.d("index", maxIndex.toString());
//        Log.d("score", maxScore.toString());
        // convert output to DoubleArray (as serializer expect)
        var result = DoubleArray(6)
        // no object found
        if (maxIndex == -1) {
            result = DoubleArray(6){0.0}
        }else {
            val newArr = outputBuffer.copyOfRange(maxIndex, maxIndex + 6)
            for (j in 0..5){
                result[j] = newArr[j].toDouble()
            }
        }
        Log.d("MAX SCORE",maxScore.toString());
        Log.d("INDEX",maxIndex.toString());

//        for (j in result.indices)
//        Log.d("RESULT $j=>",result[j].toString());

        return result


    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->

            if (call.method == "getWhiteboardPredictions") {
                val output = initPredictions(call.arguments as DoubleArray)

                    result.success(output)


            } else {
                result.notImplemented()
            }
        }
    }
}

