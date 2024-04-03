import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        enabled: true,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60.0,
                    height: 60.0,
                    color: Colors.white,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.0),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 8.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.0),
                        ),
                        Container(
                          width: double.infinity,
                          height: 8.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.0),
                        ),
                        Container(
                          width: 50.0,
                          height: 8.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
              ),
              Row(
                children: [
                  Container(
                    width: 230,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  Spacer(),
                  Container(
                    width: 40,
                    height: 8.0,
                    color: Colors.white,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
              ),
              SizedBox(
                height: 150,
                child: ListView.separated(
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150.0,
                          height: 100.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.0),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 100,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                            ),
                            Container(
                              width: 40,
                              height: 8.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                        ),
                        Container(
                          width: 50.0,
                          height: 8.0,
                          color: Colors.white,
                        ),
                      ],
                    ),itemCount: 3),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
              ),
              Row(
                children: [
                  Container(
                    width: 230,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  Spacer(),
                  Container(
                    width: 40,
                    height: 8.0,
                    color: Colors.white,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 7.0),
              ),
              SizedBox(
                height: 150,
                child: ListView.separated(
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150.0,
                          height: 100.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.0),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 100,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                            ),
                            Container(
                              width: 40,
                              height: 8.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                        ),
                        Container(
                          width: 50.0,
                          height: 8.0,
                          color: Colors.white,
                        ),
                      ],
                    ),itemCount: 3),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
              ),
              Row(
                children: [
                  Container(
                    width: 230,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  Spacer(),
                  Container(
                    width: 40,
                    height: 8.0,
                    color: Colors.white,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 7.0),
              ),
              SizedBox(
                height: 150,
                child: ListView.separated(
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150.0,
                          height: 100.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.0),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 100,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                            ),
                            Container(
                              width: 40,
                              height: 8.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                        ),
                        Container(
                          width: 50.0,
                          height: 8.0,
                          color: Colors.white,
                        ),
                      ],
                    ),itemCount: 3),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
