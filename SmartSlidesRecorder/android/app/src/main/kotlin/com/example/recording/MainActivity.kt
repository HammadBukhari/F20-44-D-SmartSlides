package com.example.recording

<<<<<<< HEAD
=======
import android.graphics.Bitmap
import android.graphics.BitmapFactory
>>>>>>> 74031de180b7ddb6210a845179ad80c408e26787
import android.util.Log
import androidx.annotation.NonNull
import com.example.recording.ml.ProjectorLiteModelConcrete2
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.tensorflow.lite.DataType
<<<<<<< HEAD
import org.tensorflow.lite.support.image.TensorImage
import org.tensorflow.lite.support.tensorbuffer.TensorBuffer
=======
import org.tensorflow.lite.support.common.ops.NormalizeOp
import org.tensorflow.lite.support.image.ImageProcessor
import org.tensorflow.lite.support.image.TensorImage
import org.tensorflow.lite.support.image.ops.ResizeOp
import org.tensorflow.lite.support.tensorbuffer.TensorBuffer
import java.nio.ByteBuffer
>>>>>>> 74031de180b7ddb6210a845179ad80c408e26787

class MainActivity: FlutterActivity() {
    private val CHANNEL = "SmartSlidesRecorder/YOLO"

<<<<<<< HEAD
    fun getWhiteboardPredictions(filePath: DoubleArray)  : DoubleArray{
        val model = ProjectorLiteModelConcrete2.newInstance(context)
//        val bitmap: Bitmap = BitmapFactory.decodeFile(filePath)
//        val imageProcessor = ImageProcessor.Builder()
//                .add(ResizeOp(416, 416, ResizeOp.ResizeMethod.BILINEAR))
//                .add(NormalizeOp(0f,255f))
//                .build()
//        var tImage = TensorImage(DataType.FLOAT32)
//        tImage.load(bitmap!!)
//        tImage = imageProcessor.process(tImage)
=======
    fun getWhiteboardPredictions(filePath: String)  : DoubleArray{
        val model = ProjectorLiteModelConcrete2.newInstance(context)
        val bitmap: Bitmap = BitmapFactory.decodeFile(filePath)
        val imageProcessor = ImageProcessor.Builder()
                .add(ResizeOp(416, 416, ResizeOp.ResizeMethod.BILINEAR))
                .add(NormalizeOp(0f,255f))
                .build()
        var tImage = TensorImage(DataType.FLOAT32)
        tImage.load(bitmap!!)
        tImage = imageProcessor.process(tImage)
>>>>>>> 74031de180b7ddb6210a845179ad80c408e26787


        val inputFeature0 = TensorBuffer.createFixedSize(intArrayOf(1, 416, 416, 3), DataType.FLOAT32)
//        inputFeature0.loadBuffer(tImage.buffer)
//        var input = arrayOf<Array<Array<Array<Float>>>>()
//        for (i in 0..255){
//            for (j in 0..255){
//                for (k in 0..2){
//                    input[0][i][j][k] = 1f
//                }
//            }
//        }
//        val input = FloatArray(1*416*416*3){1f}
//        inputFeature0.loadArray(input)
//         Runs model inference and gets result.
<<<<<<< HEAD

//        inputFeature0.loadBuffer()
         var tImage = TensorImage(DataType.FLOAT32)
        val floatArray = FloatArray(filePath.size)
        for (i in 0 until filePath.size) {
            floatArray[i] = filePath.get(i).toFloat()
        }
        tImage.load(floatArray, intArrayOf(1,416,416,3));
        inputFeature0.loadBuffer(tImage.buffer)


        val outputs = model.process(inputFeature0)
        val outputFeature0  : TensorBuffer= outputs.outputFeature0AsTensorBuffer
//        Log.d("DATA TYPE", outputFeature0.dataType.toString());
=======
        inputFeature0.loadBuffer(tImage.buffer)
        val outputs = model.process(inputFeature0)
        val outputFeature0  : TensorBuffer= outputs.outputFeature0AsTensorBuffer
        Log.d("DATA TYPE", outputFeature0.dataType.toString());
>>>>>>> 74031de180b7ddb6210a845179ad80c408e26787
        val array = outputFeature0.floatArray
        // 15210
        



<<<<<<< HEAD
//        Log.d("test", array.size.toString());
//        Log.d("buffer0", array[0].toString());
//        Log.d("buffer1", array[1].toString());
//        Log.d("buffer2", array[2].toString());
//        Log.d("buffer3", array[3].toString());
//        Log.d("buffer4", array[4].toString());
//        Log.d("buffer5", array[5].toString());
//        for (i in 13000 until 14000){
//            Log.d("Output $i", array[i].toString());
//
//        }
=======
        Log.d("test", array.size.toString());
>>>>>>> 74031de180b7ddb6210a845179ad80c408e26787
        var i = 0
        var maxIndex : Int = -1
        var maxScore : Float = 0F
        while (i < array.size){
            val score = array[i + 4] * array[i + 5]
<<<<<<< HEAD

            if (score > 0.4 && score > maxScore){
                maxScore = score
                maxIndex = i
=======
            if (i == 13716){
                Log.d("13716***", score.toString());
            }
            if (score > maxScore){
                maxScore = score
                maxIndex = i/6
>>>>>>> 74031de180b7ddb6210a845179ad80c408e26787
            }
            i+=6;
        }
        Log.d("arary index", maxIndex.toString());
        Log.d("score", maxScore.toString());
<<<<<<< HEAD
        val newArr = array.copyOfRange(maxIndex, maxIndex + 6) //outputFeature0.shape;
=======
        val newArr = array.copyOfRange(maxIndex, maxIndex + 6); //outputFeature0.shape;
>>>>>>> 74031de180b7ddb6210a845179ad80c408e26787
        val result = DoubleArray(6)

        for (j in 0..5){
            result[j] = newArr[j].toDouble()
        }
        return result


    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->

            if (call.method == "getWhiteboardPredictions") {
<<<<<<< HEAD
                val shape = getWhiteboardPredictions(call.arguments as DoubleArray)
=======
                val shape = getWhiteboardPredictions(call.arguments as String)
>>>>>>> 74031de180b7ddb6210a845179ad80c408e26787

                    result.success(shape)


            } else {
                result.notImplemented()
            }
        }
    }
}
