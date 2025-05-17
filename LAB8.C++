#include <iostream>
#include <functional>
#include <vector>
#include <chrono>
#include <ctime>
#include <string>

using namespace std;

struct LogEntry {
    vector<double> params;
    string result;
    string date;
};

vector<LogEntry> logData;

string myDivide(double a, double b) {
    double res = a / b;
    return to_string(a) + " поделить на " + to_string(b) + " равно " + to_string(res);
}

function<string(double, double)> protectFromZero(function<string(double, double)> func) {
    return [func](double a, double b) {
        if (b == 0) {
            return string("Ошибка: деление на ноль!");
        }
        return func(a, b);
    };
}

function<string(double, double)> logDecorator(function<string(double, double)> func) {
    return [func](double a, double b) {
        string result = func(a, b);
        time_t now = time(0);
        string timeStr = ctime(&now);
        timeStr.pop_back();

        LogEntry entry;
        entry.params = {a, b};
        entry.result = result;
        entry.date = timeStr;

        logData.push_back(entry);

        return result;
    };
}

int main() {
    function<string(double, double)> decoratedDiv =
        logDecorator(protectFromZero(function<string(double, double)>(myDivide)));

    double a, b;
    for (int i = 0; i < 3; ++i) {
        cout << "Введите два числа (a и b): ";
        cin >> a >> b;
        string result = decoratedDiv(a, b);
        cout << "Результат: " << result << endl << endl;
    }

    cout << "\nЖурнал вызовов:\n";
    for (const auto& entry : logData) {
        cout << "Параметры: ";
        for (double p : entry.params) {
            cout << p << " ";
        }
        cout << "\nРезультат: " << entry.result;
        cout << "\nДата вызова: " << entry.date << "\n\n";
    }

    return 0;
}
