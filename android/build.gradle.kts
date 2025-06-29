import org.gradle.api.tasks.Delete
import org.gradle.api.Project
import org.gradle.api.initialization.dsl.ScriptHandler
import org.gradle.kotlin.dsl.*

buildscript {
    repositories {
        google()
        mavenCentral()
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Set a shared build directory to avoid duplicate outputs
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    layout.buildDirectory.set(newSubprojectBuildDir)
    evaluationDependsOn(":app")
}

// ✅ Clean task for all modules
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
