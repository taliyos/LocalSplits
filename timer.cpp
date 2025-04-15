#include "timer.h"
#include <iostream>
#include <stdlib.h>
#include <unistd.h>


Timer::Timer(QObject *parent) : QObject{parent} {

    timer.start();
    std::cout << "HERE!!" << std::endl;
    std::cout << timer.elapsed() << std::endl;
}
