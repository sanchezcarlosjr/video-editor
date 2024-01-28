OPENCV_VERSION='4.9.0'
OPENCV_CONTRIB='YES'
TMPDIR=$(mktemp -d)

# Build and install OpenCV from source.
cd "${TMPDIR}"
wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip
unzip ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip
mv opencv-${OPENCV_VERSION} OpenCV

if [ $OPENCV_CONTRIB = 'YES' ]; then
  wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip
  unzip ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip
  mv opencv_contrib-${OPENCV_VERSION} opencv_contrib
  mv opencv_contrib OpenCV
fi

cd OpenCV && mkdir build && cd build

if [ $OPENCV_CONTRIB = 'NO' ]; then
cmake -DWITH_QT=ON -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON -DWITH_GSTREAMER=ON \
      -DWITH_XINE=ON -DENABLE_PRECOMPILED_HEADERS=OFF ..
fi

if [ $OPENCV_CONTRIB = 'YES' ]; then
cmake -DWITH_QT=ON -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=OFF -DWITH_GDAL=ON -DWITH_GSTREAMER=ON \
      -DWITH_XINE=ON -DENABLE_PRECOMPILED_HEADERS=OFF \
      -DWITHPYTHON_DEFAULT_EXECUTABLE=$CONDA_PREFIX/lib/python3.10 \
      -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules ..
fi

make -j8
sudo make install
sudo ldconfig

